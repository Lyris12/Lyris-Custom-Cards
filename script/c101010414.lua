--F・HEROドラグーンЯ
local id,ref=GIR()
function ref.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(ref.fscon)
	e1:SetOperation(ref.fsop)
	c:RegisterEffect(e1)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(0x8f)
	e4:SetOperation(ref.desop2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_ADJUST)
	c:RegisterEffect(e5)
	--If this card in your possession would be returned to the Extra Deck while it is on the Monster Zone, place it face-down in your Spell/Trap Zone instead.
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EFFECT_SEND_REPLACE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(ref.reptg)
	c:RegisterEffect(e6)
	--After activation: Target 1 monster your opponent controls; inflict damage to your opponent equal to its ATK, then, Special Summon this card, and if you do, destroy that target.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010161,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(ref.actcon)
	e2:SetTarget(ref.acttg)
	e2:SetOperation(ref.act)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(101010161,1))
	e3:SetCode(EVENT_CHAINING)
	c:RegisterEffect(e3)
	--If this card in your possession is destroyed: Special Summon it in face-up Defense Position.
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCondition(ref.con)
	e7:SetTarget(ref.tg)
	e7:SetOperation(ref.op)
	c:RegisterEffect(e7)
end
function ref.material(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x5d)
end
function ref.fscon(e,g,gc,chkf)
	if g==nil then return true end
	if not gc then
		local loc1=LOCATION_SZONE
		local loc2=LOCATION_SZONE
		if not g:Filter(Card.IsControler,nil,e:GetHandlerPlayer()):IsExists(Card.IsOnField,1,nil) then loc1=0 end
		if not g:Filter(Card.IsControler,nil,1-e:GetHandlerPlayer()):IsExists(Card.IsOnField,1,nil) then loc2=0 end
		local mc=g:GetFirst()
		while mc do
			local lct=mc:GetLocation()
			local p=mc:GetControler()
			if p==e:GetHandlerPlayer() then loc1=bit.bor(loc1,lct) else loc2=bit.bor(loc2,lct) end
			mc=g:GetNext()
		end
		local sg=Duel.GetMatchingGroup(ref.material,e:GetHandlerPlayer(),loc1,loc2,nil)
	end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if sg then mg:Merge(sg) end
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		if (gc:IsCode(76263644) or gc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)) and mg:IsExists(ref.material,1,gc) then
			return true
		elseif ref.material(gc) then
			local g1=Group.CreateGroup()
			local tc=mg:GetFirst()
			while tc do
				if tc:IsCode(76263644) or tc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
					then g1:AddCard(tc) end
				tc=mg:GetNext()
			end
			g1:RemoveCard(gc)
			return g1:GetCount()>0
		else return false end
	end
	local b1=0 local b2=0 local bw=0
	local fs=false
	local tc=mg:GetFirst()
	while tc do
		local c1=tc:IsCode(76263644) or tc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
		local c2=ref.material(tc)
		if c1 or c2 then
			if aux.FConditionCheckF(tc,chkf) then fs=true end
			if c1 and c2 then bw=bw+1
			elseif c1 then b1=1
			else b2=b2+1
			end
		end
		tc=mg:GetNext()
	end
	if b2>1 then b2=1 end
	return b1+b2+bw>=2 and (fs or chkf==PLAYER_NONE)
end
function ref.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if not gc then
		local loc1=LOCATION_SZONE
		local loc2=LOCATION_SZONE
		if not eg:Filter(Card.IsControler,nil,tp):IsExists(Card.IsOnField,1,nil) then loc1=0 end
		if not eg:Filter(Card.IsControler,nil,1-tp):IsExists(Card.IsOnField,1,nil) then loc2=0 end
		local mc=eg:GetFirst()
		while mc do
			local lct=mc:GetLocation()
			local p=mc:GetControler()
			if p==e:GetHandlerPlayer() then loc1=bit.bor(loc1,lct) else loc2=bit.bor(loc2,lct) end
			mc=eg:GetNext()
		end
		local mg=Duel.GetMatchingGroup(ref.material,e:GetHandlerPlayer(),loc1,loc2,nil)
	end
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if mg then g:Merge(mg) end
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return end
		if (gc:IsCode(76263644) or gc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)) and g:IsExists(ref.material,1,gc) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g1=g:FilterSelect(tp,ref.material,1,1,gc)
			Duel.SetFusionMaterial(g1)
		else
			local sg1=Group.CreateGroup() local sg2=Group.CreateGroup()
			local tc=g:GetFirst()
			while tc do
				if tc:IsCode(76263644) or tc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) then sg1:AddCard(tc) end
				if ref.material(tc) then sg2:AddCard(tc) end
				tc=g:GetNext()
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g1=sg1:Select(tp,1,1,gc)
			Duel.SetFusionMaterial(g1)
		end
		return
	end
	local sg1=Group.CreateGroup() local sg2=Group.CreateGroup() local fs=false
	local tc=g:GetFirst()
	while tc do
		if tc:IsCode(76263644) or tc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) then sg1:AddCard(tc) end
		if ref.material(tc) then sg2:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		tc=g:GetNext()
	end
	if chkf~=PLAYER_NONE then
		if sg2:GetCount()==1 then
			sg1:Sub(sg2)
		end
		local g1=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		if fs then g1=sg1:Select(tp,1,1,nil)
			else g1=sg1:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf) end
		local tc1=g1:GetFirst()
		sg2:RemoveCard(tc1)
		if aux.FConditionCheckF(tc1,chkf) or sg2:GetCount()==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g2=sg2:Select(tp,1,1,tc1)
			g1:Merge(g2)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g2=sg2:FilterSelect(tp,aux.FConditionCheckF,1,1,tc1,chkf)
			g1:Merge(g2)
		end
		Duel.SetFusionMaterial(g1)
	else
		if sg2:GetCount()==1 then
			sg1:Sub(sg2)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g1:Merge(sg2:Select(tp,1,1,g1:GetFirst()))
		Duel.SetFusionMaterial(g1)
	end
end
function ref.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsOnField() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function ref.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return re~=e and c:IsControler(c:GetOwner()) and bit.band(c:GetDestination(),0x43)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) then
		Duel.RegisterFlagEffect(tp,101010161,RESET_PHASE+PHASE_END,0,1)
		return true
	else return false end
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousControler()==tp
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	end
end
function ref.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101010161)==0 and (not e:GetHandler():IsStatus(STATUS_SET_TURN) or e:GetHandler():GetFlagEffect(101010170)~=0)
end
function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function ref.act(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		if ev~=0 then
			local ef=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			if ef~=nil and ef:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then Card.ReleaseEffectRelation(c,ef) end
		end
		ref.after(e,tp)
	end
end
function ref.after(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	local atk=0
	if tc:IsFaceup() then atk=tc:GetAttack() end
	Duel.BreakEffect()
	if Duel.Damage(1-tp,atk,REASON_EFFECT)~=0 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
