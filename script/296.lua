--真黒竜サイバー・ダークネス・ドラゴン "THE NIGHT"
function c101010039.initial_effect(c)
	--grave-down
	local atd=Effect.CreateEffect(c)
	atd:SetType(EFFECT_TYPE_SINGLE)
	atd:SetCode(EFFECT_UPDATE_ATTACK)
	atd:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	atd:SetRange(LOCATION_MZONE)
	atd:SetValue(c101010039.atkval)
	c:RegisterEffect(atd)
	local dfd=atd:Clone()
	dfd:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(dfd)
	--equip
	local eq=Effect.CreateEffect(c)
	eq:SetCategory(CATEGORY_EQUIP)
	eq:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	eq:SetCode(EVENT_SPSUMMON_SUCCESS)
	eq:SetProperty(EFFECT_FLAG_CARD_TARGET)
	eq:SetTarget(c101010039.eqtg)
	eq:SetOperation(c101010039.eqop)
	c:RegisterEffect(eq)
	--copy
	local cp=Effect.CreateEffect(c)
	cp:SetDescription(aux.Stringid(101010039,1))
	cp:SetType(EFFECT_TYPE_QUICK_O)
	cp:SetCode(EVENT_FREE_CHAIN)
	cp:SetRange(LOCATION_MZONE)
	cp:SetCountLimit(1)
	cp:SetCondition(c101010039.con)
	cp:SetCost(c101010039.scost)
	cp:SetOperation(c101010039.soperation)
	c:RegisterEffect(cp)
	--Destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetCondition(c101010039.con)
	e7:SetTarget(c101010039.desreptg)
	e7:SetOperation(c101010039.desrepop)
	c:RegisterEffect(e7)
	if not c101010039.global_check then
		c101010039.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010039.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010039.evolute=true
c101010039.material1=function(mc) return mc:IsCode(40418351) and mc:IsFaceup() end
c101010039.material2=function(mc) return mc:GetLevel()==4 and mc:IsFaceup() end
function c101010039.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
end
function c101010039.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+8751
end
function c101010039.addc(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():AddCounter(0x88,8)
end
function c101010039.rfilter(c)
	return c:GetLevel()==4
end
function c101010039.spfilter(c)
	return c:GetCode()==40418351 or c:GetCode()==40418352
end
function c101010039.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(c101010039.spfilter,tp,LOCATION_MZONE,0,nil)
	if g1:GetCount()>0 then
		local g2=Duel.IsExistingMatchingCard(c101010039.rfilter,tp,LOCATION_MZONE,0,1,g1:GetFirst())
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and g2
	end
	return false
end
function c101010039.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g2=Duel.SelectMatchingCard(tp,c101010039.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local g1=Duel.SelectMatchingCard(tp,c101010039.rfilter,tp,LOCATION_MZONE,0,1,1,g2:GetFirst())
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c101010039.efilter1(e,te)
	return te:IsActiveType(TYPE_TRAP) or te:IsActiveType(TYPE_SPELL)
end
function c101010039.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c101010039.acos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010039.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c101010039.cfilter,1,1,REASON_COST)
end
function c101010039.addct2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x88)
end
function c101010039.addc2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x88,3)
	end
end
function c101010039.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x88)>2
end
function c101010039.efilter(e,te)
	return  te:IsHasCategory(CATEGORY_NEGATE+CATEGORY_DISABLE)-- and te:GetCode()~=97268402
end
function c101010039.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)*(-100)
end
function c101010039.filter(c)
	return c:IsRace(RACE_DRAGON)
end
function c101010039.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010039.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	and Duel.IsExistingTarget(c101010039.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c101010039.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,0,0)
end
function c101010039.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tg=Duel.SelectMatchingCard(tp,c101010039.filter,tp,0,LOCATION_GRAVE,0,ft-1,tc,e,tp)
	tg:AddCard(tc)
	local tgc=tg:GetFirst()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		while tgc do
			local atk=tgc:GetTextAttack()
			if atk<0 then atk=0 end
			if not Duel.Equip(tp,tgc,c,false) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c101010039.eqlimit)
			tgc:RegisterEffect(e1)
			tgc=tg:GetNext()
		end
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c101010039.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c101010039.eqlimit(e,c)
	return e:GetOwner()==c
end
function c101010039.repval(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c101010039.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	return c:GetCounter(0x88)>2
end
function c101010039.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,4,REASON_COST)
end
function c101010039.soperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local wg=Duel.GetMatchingGroup(c101010039.filter,tp,LOCATION_SZONE,0,nil)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
			c:CopyEffect(code,RESET_EVENT+EVENT_CHAINING,1)
			c:RegisterFlagEffect(code,RESET_EVENT+EVENT_CHAINING,0,1)
		end
		wbc=wg:GetNext()
	end
end
function c101010039.repfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c101010039.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(c101010039.repfilter,1,nil)
	end
	local g=c:GetEquipGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:FilterSelect(tp,c101010039.repfilter,1,1,nil)
	Duel.SetTargetCard(sg)
	return true
end
function c101010039.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
