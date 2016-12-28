--created & coded by Lyris
--The dwarfed CHARON
function c101010199.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101010199.target)
	e1:SetOperation(c101010199.operation)
	c:RegisterEffect(e1)
end
function c101010199.filter(c,e,tp)
	return c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function c101010199.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(c101010199.filter,tp,0,LOCATION_MZONE,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c101010199.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,hg)
	Duel.ShuffleHand(1-tp)
	local ct=g:GetCount()
	if ct>0 then
		local c=e:GetHandler()
		local sg=Duel.GetMatchingGroup(c101010199.filter,tp,0,LOCATION_MZONE,nil,e)
		local b1=true
		local b2=true
		local b3=true
		local off=0
		local sel=0
		repeat
			local ops={}
			local opval={}
			off=1
			if b1 then
				ops[off]=aux.Stringid(101010199,1)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(101010199,2)
				opval[off-1]=2
				off=off+1
			end
			if b3 then
				ops[off]=aux.Stringid(101010199,3)
				opval[off-1]=3
				off=off+1
			end
			local op=Duel.SelectOption(tp,table.unpack(ops))
			if opval[op]==1 then
				sel=sel+1
				b1=false
			elseif opval[op]==2 then
				sel=sel+2
				b2=false
			else
				sel=sel+4
				b3=false
			end
			ct=ct-1
		until ct==0 or off<3 or not Duel.SelectYesNo(tp,aux.Stringid(101010199,4))
		if bit.band(sel,1)~=0 then
			local bc=sg:Select(tp,1,1,nil):GetFirst()
			Duel.HintSelection(Group.FromCards(bc))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(b:GetBaseAttack())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			bc:RegisterEffect(e1)
		end
		if bit.band(sel,2)~=0 then
			local a=sg:Select(tp,1,1,nil):GetFirst()
			Duel.HintSelection(Group.FromCards(a))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			a:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			a:RegisterEffect(e2)
			local code=a:GetOriginalCode()
			c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		end
		if bit.band(sel,4)~=0 then
			local ad=sg:Select(tp,1,1,nil):GetFirst()
			Duel.HintSelection(Group.FromCards(ad))
			local code=ad:GetCode()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			ad:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetCode(EFFECT_ADD_CODE)
			e2:SetValue(code)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e2)
		end
	end
end
