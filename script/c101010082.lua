--This card can attack your opponent directly, but when it does so using this effect, any battle damage it inflicts to your opponent is halved.
--ＳＳ－スピリット・キャンパー
local id,ref=GIR()
function ref.start(c)
--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(ref.spcon)
	c:RegisterEffect(e2)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(ref.con1)
	e1:SetTarget(ref.tg1)
	e1:SetOperation(ref.op1)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_BE_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e0:SetCondition(ref.con2)
	e0:SetTarget(ref.tg2)
	e0:SetOperation(ref.op2)
	c:RegisterEffect(e0)
end
function ref.spfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function ref.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandler():GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function ref.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function ref.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function ref.cfilter2(c)
	if c:GetFlagEffect(id)~=0 then return false end
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and (c:GetSummonLocation()==LOCATION_EXTRA and c:IsType(TYPE_SYNCHRO))
end
function ref.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rc=e:GetHandler():GetReasonCard()
	if chkc then return chkc:IsOnField() and ref.filter(chkc) end
	if chk==0 then return rc:IsAttribute(ATTRIBUTE_WATER) and Duel.IsExistingMatchingCard(ref.cfilter2,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(ref.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,rc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function ref.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		local c=e:GetHandler()
		local sc=c:GetReasonCard()
		if sc:IsFacedown() then return end
		sc:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CANNOT_DISABLE,1)
		if tc:IsType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(atk/2)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1)
			elseif tc:IsType(TYPE_SPELL) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DESTROY_REPLACE)
			e2:SetTarget(ref.indtg)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e2)
			else
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e3)
		end
	 end
end
function ref.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_SYNCHRO)
end
function ref.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rc=e:GetHandler():GetReasonCard()
	if chkc then return chkc:IsOnField() and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(ref.cfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(ref.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,rc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function ref.cfilter1(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:GetSummonLocation()==LOCATION_DECK and c:GetFlagEffect(id)==0
end
function ref.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		local c=e:GetHandler()
		local sg=Duel.SelectMatchingCard(tp,ref.cfilter1,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(sg)
		local sc=sg:GetFirst()
		if not sc or sc:IsFacedown() then return end
		sc:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CANNOT_DISABLE,1)
		if tc:IsType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(atk/2)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1)
			elseif tc:IsType(TYPE_SPELL) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DESTROY_REPLACE)
			e2:SetTarget(ref.indtg)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e2)
			else
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e3)
		end
	end
end
function ref.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsContains(e:GetHandler()) and r==REASON_EFFECT end
	return true
end
