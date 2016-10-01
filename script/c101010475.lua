--Monument Bronzeboard
function c101010475.initial_effect(c)
	--Fusion Material: 2 Level 4, 5, or 6 LIGHT Machine-Type monsters
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c101010475.ffilter,2,false)
	--Must first be Fusion Summoned with the above Fusion Materials.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--During either player's turn: You can target 2 face-up monsters your opponent controls, and apply the appropriate effects with both of those targets, depending on the original Levels of the monsters used as Fusion Material (in sequence); (effects below) You can only use this effect of "Monument Bronzeboard" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c101010475.matchk)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101010475)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetLabel(0)
	e2:SetLabelObject(e1)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION end)
	e2:SetTarget(c101010475.target)
	e2:SetOperation(c101010475.operation)
	c:RegisterEffect(e2)
end
function c101010475.ffilter(c)
	return c:IsLevelAbove(4) and c:IsLevelBelow(6) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
end
function c101010475.matchk(e,c)
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local lvt=0
	while tc do
		local lv=tc:GetLevel()
		if lv==4 then
			if bit.band(lvt,0x1)==0 then lvt=bit.bor(lvt,0x1) end
		elseif lv==5 then
			if bit.band(lvt,0x2)==0 then lvt=bit.bor(lvt,0x2) end
		else
			if bit.band(lvt,0x4)==0 then lvt=bit.bor(lvt,0x4) end
		end
		tc=g:GetNext()
	end
	e:SetLabel(lvt)
end
function c101010475.mfilter(c,n)
	return c:GetLevel()==n
end
function c101010475.filter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c101010475.filter1(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c101010475.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lvc=e:GetLabelObject():GetLabel()
	local mg=e:GetHandler():GetMaterial()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101010475.filter,tp,0,LOCATION_MZONE,2,nil,mg) end
	local tg=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,0,LOCATION_MZONE,nil,e)
	local tr=Group.CreateGroup()
	if bit.band(lvc,0x1)==0x1 then
		e:SetLabel(e:GetLabel()+0x1)
		e:SetCategory(e:GetCategory()+CATEGORY_DISABLE)
		local ct1=mg:FilterCount(c101010475.mfilter,nil,4)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg1=tg:FilterSelect(tp,c101010475.filter,1,ct1,nil)
		tr:Merge(tg1)
		tg:Sub(tg1)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,tg1,tg1:GetCount(),0,0)
	end
	if bit.band(lvc,0x2)==0x2 then
		e:SetLabel(e:GetLabel()+0x2)
		e:SetCategory(e:GetCategory()+CATEGORY_DESTROY)
		local ct2=mg:FilterCount(c101010475.mfilter,nil,5)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tg2=tg:FilterSelect(tp,c101010475.filter1,1,ct2,nil)
		tr:Merge(tg2)
		tg:Sub(tg2)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg2,tg2:GetCount(),0,0)
	end
	if bit.band(lvc,0x4)==0x4 then
		e:SetLabel(e:GetLabel()+0x4)
		e:SetCategory(e:GetCategory()+CATEGORY_DAMAGE)
		local ct3=mg:FilterCount(c101010475.mfilter,nil,6)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg3=tg:FilterSelect(tp,aux.TRUE,1,ct3,nil)
		tr:Merge(tg3)
		if mg:IsExists(c101010475.mfilter,2,nil,6) then Duel.SetTargetPlayer(1-tp) end
		local dam=0
		local tc=tg3:GetFirst()
		while tc do
			dam=dam+tc:GetAttack()
			tc=tg3:GetNext()
		end
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	end
	Duel.SetTargetCard(tr)
end
function c101010475.filter3(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c101010475.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c101010475.filter3,nil,e)
	if tg:GetCount()~=2 then return end
	local mg=c:GetMaterial()
	local ex1,tg1=Duel.GetOperationInfo(0,CATEGORY_DISABLE)
	local ex2,tg2=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local g=tg:Clone()
	if bit.band(e:GetLabel(),0x1)==0x1 then
		--Level 4: Negate 1 of those targets' effects.
		if mg:IsExists(c101010475.mfilter,2,nil,4) then tg1=tg end
		local tc1=tg1:GetFirst()
		while tc1 do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc1:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc1:RegisterEffect(e2)
			tc1=tg1:GetNext()
		end
		g:Sub(tg1)
	end
	if bit.band(e:GetLabel(),0x2)==0x2 then
		--Level 5: Destroy 1 of those targets.
		if bit.band(e:GetLabel(),0x1)==0x1 then Duel.BreakEffect() end
		if mg:IsExists(c101010475.mfilter,2,nil,5) then tg2=tg end
		Duel.Destroy(tg2,REASON_EFFECT)
		g:Sub(tg2)
	end
	if bit.band(e:GetLabel(),0x4)==0x4 then
		--Level 6: Inflict damage to your opponent equal to 1 of those targets' ATK on the field.
		local dam=0
		if bit.band(e:GetLabel(),0x3)~=0 then Duel.BreakEffect() end
		if mg:IsExists(c101010475.mfilter,2,nil,6) then
			local tc2=tg:GetFirst()
			while tc2 do
				dam=dam+tc2:GetAttack()
				tc2=tg:GetNext()
			end
		else
			dam=g:GetFirst():GetAttack()
		end
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
